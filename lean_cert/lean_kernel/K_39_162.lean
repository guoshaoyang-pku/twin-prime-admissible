import Sound
import lean_certs.cert_39_162

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_162_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 39) (d := 162) (c := cert_39_162) (by decide)
