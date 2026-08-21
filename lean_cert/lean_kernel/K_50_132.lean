import Sound
import lean_certs.cert_50_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_132_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 50) (d := 132) (c := cert_50_132) (by decide)
