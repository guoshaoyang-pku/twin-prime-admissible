import Sound
import lean_certs.cert_43_160

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_160_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 160 := by
  exact certValidRoot_sound (k := 43) (d := 160) (c := cert_43_160) (by decide)
