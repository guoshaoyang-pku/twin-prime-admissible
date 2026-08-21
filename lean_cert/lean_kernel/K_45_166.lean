import Sound
import lean_certs.cert_45_166

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_166_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 45) (d := 166) (c := cert_45_166) (by decide)
