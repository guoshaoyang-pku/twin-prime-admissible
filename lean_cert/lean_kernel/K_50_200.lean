import Sound
import lean_certs.cert_50_200

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_200_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 200 := by
  exact certValidRoot_sound (k := 50) (d := 200) (c := cert_50_200) (by decide)
