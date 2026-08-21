import Sound
import lean_certs.cert_46_162

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_162_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 46) (d := 162) (c := cert_46_162) (by decide)
