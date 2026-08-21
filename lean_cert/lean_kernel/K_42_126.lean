import Sound
import lean_certs.cert_42_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_126_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 42) (d := 126) (c := cert_42_126) (by decide)
