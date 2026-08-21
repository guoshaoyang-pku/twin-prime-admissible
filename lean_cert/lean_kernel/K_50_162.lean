import Sound
import lean_certs.cert_50_162

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_162_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 50) (d := 162) (c := cert_50_162) (by decide)
