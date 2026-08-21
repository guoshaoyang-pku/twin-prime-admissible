import Sound
import lean_certs.cert_44_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_126_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 44) (d := 126) (c := cert_44_126) (by decide)
