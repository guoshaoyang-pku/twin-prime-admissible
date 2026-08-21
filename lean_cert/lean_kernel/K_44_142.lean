import Sound
import lean_certs.cert_44_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_142_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 44) (d := 142) (c := cert_44_142) (by decide)
