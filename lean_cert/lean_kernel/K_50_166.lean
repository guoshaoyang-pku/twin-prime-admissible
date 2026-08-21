import Sound
import lean_certs.cert_50_166

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_166_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 50) (d := 166) (c := cert_50_166) (by decide)
