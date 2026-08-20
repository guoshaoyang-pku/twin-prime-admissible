import Sound
import lean_certs.cert_48_152

open CertVerify

theorem H48_gt_152 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 152 := by
  exact certValidRoot_sound (k := 48) (d := 152) (c := cert_48_152) (by native_decide)
