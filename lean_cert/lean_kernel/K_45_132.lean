import Sound
import lean_certs.cert_45_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_132_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 45) (d := 132) (c := cert_45_132) (by decide)
