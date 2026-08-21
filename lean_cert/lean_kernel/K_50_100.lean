import Sound
import lean_certs.cert_50_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_100_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 50) (d := 100) (c := cert_50_100) (by decide)
