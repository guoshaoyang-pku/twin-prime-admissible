import Sound
import lean_certs.cert_46_148

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_148_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 46) (d := 148) (c := cert_46_148) (by decide)
