import Sound
import lean_certs.cert_37_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_126_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 37) (d := 126) (c := cert_37_126) (by decide)
