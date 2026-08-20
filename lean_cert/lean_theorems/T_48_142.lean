import Sound
import lean_certs.cert_48_142

open CertVerify

theorem H48_gt_142 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 48) (d := 142) (c := cert_48_142) (by native_decide)
