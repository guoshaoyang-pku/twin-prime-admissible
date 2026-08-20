import Sound
import lean_certs.cert_48_202

open CertVerify

theorem H48_gt_202 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 202 := by
  exact certValidRoot_sound (k := 48) (d := 202) (c := cert_48_202) (by native_decide)
