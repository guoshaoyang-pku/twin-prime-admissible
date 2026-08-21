import Sound
import lean_certs.cert_31_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_126_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 31) (d := 126) (c := cert_31_126) (by decide)
