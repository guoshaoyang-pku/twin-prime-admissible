import Sound
import lean_certs.cert_49_152

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_152_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 49) (d := 152) (c := cert_49_152) (by decide)
