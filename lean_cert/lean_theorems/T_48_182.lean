import Sound
import lean_certs.cert_48_182

open CertVerify

theorem H48_gt_182 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 48) (d := 182) (c := cert_48_182) (by native_decide)
