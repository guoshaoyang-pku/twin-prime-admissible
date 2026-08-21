import Sound
import lean_certs.cert_44_132

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_132_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 44) (d := 132) (c := cert_44_132) (by decide)
