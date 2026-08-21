import Sound
import lean_certs.cert_43_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_100_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 43) (d := 100) (c := cert_43_100) (by decide)
