import Sound
import lean_certs.cert_49_182

open CertVerify

theorem H49_gt_182 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 182 := by
  exact certValidRoot_sound (k := 49) (d := 182) (c := cert_49_182) (by native_decide)
