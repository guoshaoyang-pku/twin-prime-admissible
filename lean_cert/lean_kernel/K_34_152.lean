import Sound
import lean_certs.cert_34_152

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H34_gt_152_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 34) (d := 152) (c := cert_34_152) (by decide)
