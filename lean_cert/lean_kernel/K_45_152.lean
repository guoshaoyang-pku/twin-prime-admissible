import Sound
import lean_certs.cert_45_152

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_152_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 45) (d := 152) (c := cert_45_152) (by decide)
