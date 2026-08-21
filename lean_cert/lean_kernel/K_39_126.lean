import Sound
import lean_certs.cert_39_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_126_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 39) (d := 126) (c := cert_39_126) (by decide)
