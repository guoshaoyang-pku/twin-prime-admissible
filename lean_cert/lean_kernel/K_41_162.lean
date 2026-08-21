import Sound
import lean_certs.cert_41_162

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_162_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 41) (d := 162) (c := cert_41_162) (by decide)
