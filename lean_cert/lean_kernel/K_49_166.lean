import Sound
import lean_certs.cert_49_166

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_166_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 49) (d := 166) (c := cert_49_166) (by decide)
