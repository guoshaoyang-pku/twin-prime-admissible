import Sound
import lean_certs.cert_43_92

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_92_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 43) (d := 92) (c := cert_43_92) (by decide)
