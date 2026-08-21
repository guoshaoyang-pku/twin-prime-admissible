import Sound
import lean_certs.cert_45_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_126_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 45) (d := 126) (c := cert_45_126) (by decide)
