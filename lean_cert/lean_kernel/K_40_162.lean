import Sound
import lean_certs.cert_40_162

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_162_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 40) (d := 162) (c := cert_40_162) (by decide)
