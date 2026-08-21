import Sound
import lean_certs.cert_45_148

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_148_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 45) (d := 148) (c := cert_45_148) (by decide)
