import Sound
import lean_certs.cert_41_148

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_148_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 41) (d := 148) (c := cert_41_148) (by decide)
