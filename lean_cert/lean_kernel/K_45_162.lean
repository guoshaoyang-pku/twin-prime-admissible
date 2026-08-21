import Sound
import lean_certs.cert_45_162

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_162_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 45) (d := 162) (c := cert_45_162) (by decide)
