import Sound
import lean_certs.cert_44_168

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_168_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 44) (d := 168) (c := cert_44_168) (by decide)
