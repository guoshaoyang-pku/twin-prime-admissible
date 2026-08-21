import Sound
import lean_certs.cert_49_162

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_162_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 162 := by
  exact certValidRoot_sound (k := 49) (d := 162) (c := cert_49_162) (by decide)
