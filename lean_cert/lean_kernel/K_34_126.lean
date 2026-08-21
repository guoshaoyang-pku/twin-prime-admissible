import Sound
import lean_certs.cert_34_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_126_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 34) (d := 126) (c := cert_34_126) (by decide)
