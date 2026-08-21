import Sound
import lean_certs.cert_37_152

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_152_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 37) (d := 152) (c := cert_37_152) (by decide)
