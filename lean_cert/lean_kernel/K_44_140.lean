import Sound
import lean_certs.cert_44_140

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_140_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 44) (d := 140) (c := cert_44_140) (by decide)
