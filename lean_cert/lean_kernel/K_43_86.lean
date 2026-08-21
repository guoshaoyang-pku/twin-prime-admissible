import Sound
import lean_certs.cert_43_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_86_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 43) (d := 86) (c := cert_43_86) (by decide)
