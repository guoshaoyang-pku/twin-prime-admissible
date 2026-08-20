import Sound
import lean_certs.cert_49_202

open CertVerify

theorem H49_gt_202 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 202 := by
  exact certValidRoot_sound (k := 49) (d := 202) (c := cert_49_202) (by native_decide)
