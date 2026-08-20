import Sound
import lean_certs.cert_49_142

open CertVerify

theorem H49_gt_142 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 49) (d := 142) (c := cert_49_142) (by native_decide)
