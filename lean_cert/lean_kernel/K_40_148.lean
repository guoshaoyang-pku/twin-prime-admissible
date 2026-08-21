import Sound
import lean_certs.cert_40_148

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_148_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 40) (d := 148) (c := cert_40_148) (by decide)
