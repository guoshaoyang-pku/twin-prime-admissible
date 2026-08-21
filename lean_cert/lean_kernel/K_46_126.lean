import Sound
import lean_certs.cert_46_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_126_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 46) (d := 126) (c := cert_46_126) (by decide)
