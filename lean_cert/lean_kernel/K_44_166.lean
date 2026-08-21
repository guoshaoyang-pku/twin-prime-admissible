import Sound
import lean_certs.cert_44_166

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_166_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 44) (d := 166) (c := cert_44_166) (by decide)
