import Sound
import lean_certs.cert_43_180

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_180_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 43) (d := 180) (c := cert_43_180) (by decide)
