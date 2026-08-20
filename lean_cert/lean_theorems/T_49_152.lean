import Sound
import lean_certs.cert_49_152

open CertVerify

theorem H49_gt_152 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 49) (d := 152) (c := cert_49_152) (by native_decide)
