import Sound
import lean_certs.cert_34_148

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H34_gt_148_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 34) (d := 148) (c := cert_34_148) (by decide)
