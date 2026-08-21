import Sound
import lean_certs.cert_25_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_100_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 25) (d := 100) (c := cert_25_100) (by decide)
