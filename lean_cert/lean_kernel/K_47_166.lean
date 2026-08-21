import Sound
import lean_certs.cert_47_166

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_166_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 47) (d := 166) (c := cert_47_166) (by decide)
