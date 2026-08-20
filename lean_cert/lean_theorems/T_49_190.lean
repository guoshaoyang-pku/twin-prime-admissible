import Sound
import lean_certs.cert_49_190

open CertVerify

theorem H49_gt_190 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 190 := by
  exact certValidRoot_sound (k := 49) (d := 190) (c := cert_49_190) (by native_decide)
