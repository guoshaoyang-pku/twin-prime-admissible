import Sound
import lean_certs.cert_44_152

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_152_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 44) (d := 152) (c := cert_44_152) (by decide)
