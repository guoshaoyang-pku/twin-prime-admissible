import Sound
import lean_certs.cert_39_148

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_148_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 39) (d := 148) (c := cert_39_148) (by decide)
