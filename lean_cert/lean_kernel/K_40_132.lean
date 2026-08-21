import Sound
import lean_certs.cert_40_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_132_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 40) (d := 132) (c := cert_40_132) (by decide)
