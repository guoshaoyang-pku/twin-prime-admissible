import Sound
import lean_certs.cert_42_148

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_148_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 42) (d := 148) (c := cert_42_148) (by decide)
